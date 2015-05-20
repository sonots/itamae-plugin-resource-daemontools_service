require "itamae"

module Itamae
  module Plugin
    module Resource
      class DaemontoolsService < Itamae::Resource::Base
        define_attribute :action, default: :nothing
        define_attribute :name, type: String, default_name: true

        define_attribute :directory, type: String

        def initialize(*args)
          super
        end

        def service_name
          shell_escape(attributes.name)
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
            run_specinfra(:start_service_under_daemontools, attributes.name)
          end
        end

        def action_stop(options)
          if current.enabled && current.running
            run_specinfra(:stop_service_under_daemontools, attributes.name)
          end
        end

        def action_restart(options)
          if current.enabled && current.running
            run_specinfra(:restart_service_under_daemontools, attributes.name)
          end
        end

        def action_reload(options)
          if current.enabled && current.running
            run_specinfra(:reload_service_under_daemontools, attributes.name)
          end
        end

        def action_enable(options)
          if !current.enabled
            run_specinfra(:enable_service_under_daemontools, attributes.name, attributes.directory)
          end
        end

        def action_disable(options)
          if current.enabled
            run_specinfra(:disable_service_under_daemontools, attributes.name)
          end
        end

        private

        def service_status!
          if run_command("test -L /service/#{service_name} && test -f /service/#{service_name}/run", error: false).exit_status == 0
            current.enabled = true
            result = run_command("svstat /service/#{service_name}", error: false)
            if result.exit_status == 0

              retry_count = 4
              while result.stdout =~ /: supervise not running/ or result.stdout =~ /: unable to open supervise\/ok/
                sleep 1
                retry_count -= 1
                result = run_command("svstat /service/#{service_name}", error: false)
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
