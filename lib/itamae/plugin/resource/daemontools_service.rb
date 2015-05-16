require "itamae"

module Itamae
  module Plugin
    module Resource
      class DaemontoolsService < Itamae::Resource::Base
        define_attribute :action, default: :nothing
        define_attribute :name, type: String, default_name: true

        define_attribute :service_directory, type: String, default: '/service'
        define_attribute :directory, type: String
        define_attribute :svc_command, type: String, default: '/usr/local/bin/svc'
        define_attribute :svstat_command, type: String, default: '/usr/local/bin/svstat'

        def initialize(*args)
          super
        end

        def svc_command
          shell_escape(attributes.svc_command)
        end

        def svstat_command
          shell_escape(attributes.svstat_command)
        end

        def service_name
          shell_escape(File.basename(attributes.directory))
        end

        def service_link
          "#{shell_escape(attributes.service_directory)}/#{service_name}"
        end

        def pre_action
          case @current_action
          when :start, :restart
            attributes.running = true
          when :stop
            attributes.running = false
          when :enable
            attributes.enabled = true
          when :disable
            attributes.enabled = false
          end
        end

        def set_current_attributes
          super
          service_status!
        end

        def action_start(options)
          if current.enabled && !current.running
            run_command("sudo #{svc_command} -u #{service_link}")
          end
        end

        def action_stop(options)
          if current.enabled && current.running
            run_command("sudo #{svc_command} -d #{service_link}")
          end
        end

        def action_restart(options)
          if current.enabled && current.running
            run_command("sudo #{svc_command} -t #{service_link}")
          end
        end

        def action_reload(options)
          if current.enabled && current.running
            run_command("sudo #{svc_command} -h #{service_link}")
          end
        end

        def action_enable(options)
          if !current.enabled
            # run_command("sudo ln -sf #{attributes.directory} #{service_link}")
            run_command("sudo ln -sf #{attributes.directory} #{shell_escape(attributes.service_directory)}/")
          end
        end

        def action_disable(options)
          if current.enabled
            service_dot_link = "#{shell_escape(attributes.service_directory)}/.#{service_name}"
            command = <<-"EOF"
              sudo mv #{service_link} #{service_dot_link}
              sudo #{svc_command} -dx #{service_dot_link}
              if [ -d #{service_dot_link}/log ]; then
                sudo #{svc_command} -dx #{service_dot_link}/log
              fi
              sudo rm -f #{service_dot_link}
            EOF
            run_command(command)
          end
        end

        # private

        def service_status!
          if run_command("test -L #{service_link} && test -f #{service_link}/run", error: false).exit_status == 0
            current.enabled = true
            result = run_command("sudo #{svstat_command} #{service_link}", error: false)
            if result.exit_status == 0

              retry_count = 4
              while result.stdout =~ /: supervise not running/ or result.stdout =~ /: unable to open supervise\/ok/
                sleep 1
                retry_count -= 1
                result = run_command("sudo #{svstat_command} #{service_link}", error: false)
                break if retry_count < 0
              end

              if result.stdout =~ /: up \(pid [1-9]/
                current.running = true
              elsif result.stdout =~ /: down [1-9]/
                current.running = false
              else
                current.running = false
              end
            else
              current.running = false
            end
          else
            current.enabled = false
            current.running = false
          end

          current
        end
      end
    end
  end
end
