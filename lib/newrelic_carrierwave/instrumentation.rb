require 'new_relic/agent/method_tracer'
require 'new_relic/agent/instrumentation/controller_instrumentation'

DependencyDetection.defer do
    @name = :carrierwave

    depends_on do
        NewRelic::Agent.logger.debug 'Installing CarrierWave Storage Instrumentation'
        defined?(::CarrierWave) &&
        !NewRelic::Control.instance['disable_carrierwave_storage'] &&
        ENV['NEWRELIC_ENABLE'].to_s !~ /false|off|no/i
    end

    executes do
        ::CarrierWave::Storage::Fog.class_eval do
            def call_store_with_newrelic_trace(file)
                metrics = ["External/CarrierWave/Fog/store"]

                if NewRelic::Agent::Instrumentation::MetricFrame.recording_web_transaction?
                    total_metric = 'External/allWeb'
                else
                    total_metric = 'External/allOther'
                end

                metrics << total_metric
                self.class.trace_execution_scoped(metrics) do
                    call_store_without_newrelic_trace(file)
                end
            end

            def call_retrieve_with_newrelic_trace(identifier)
                metrics = ["Custom/CarrierWave/Fog/retrieve"]
                self.class.trace_execution_scoped(metrics) do
                    call_retrieve_without_newrelic_trace(identifier)
                end
            end

            alias :call_store_without_newrelic_trace :store!
            alias :store! :call_store_with_newrelic_trace

            alias :call_retrieve_without_newrelic_trace :retrieve!
            alias :retrieve! :call_retrieve_with_newrelic_trace
        end
    end
end

DependencyDetection.defer do
    @name = :carrierwave_versions

    depends_on do
        NewRelic::Agent.logger.debug("Installing CarrierWave Version Instrumentation")
        defined?(::CarrierWave) &&
        !NewRelic::Control.instance['disable_carrierwave_version'] &&
        ENV['NEWRELIC_ENABLE'].to_s !~ /false|off|no/i
    end

    executes do
        ::CarrierWave::Uploader::Versions::ClassMethods.class_eval do
  
            def version_with_newrelic_trace(name, options = {}, &block)
                metrics = ["Custom/CarrierWave/Version/#{name}"]
                self.class.trace_execution_scoped(metrics) do
                    version_without_newrelic_trace(name, options, &block)
                end
            end
  
            alias :version_without_newrelic_trace :version
            alias :version :version_with_newrelic_trace
        end
    end
end

DependencyDetection.defer do
    @name = :carrierwave_vips_image_processing

    depends_on do
        defined?(::CarrierWave::Vips) &&
        !NewRelic::Control.instance['disable_carrierwave_image_processing'] &&
        ENV['NEWRELIC_ENABLE'].to_s !~ /false|off|no/i
    end

    executes do
        NewRelic::Agent.logger.debug 'Installing CarrierWave (VIPS) Image Processing Instrumentation'
    end

    executes do
        if defined?(::CarrierWave::Vips)
            ::CarrierWave::Vips.class_eval do
                include NewRelic::Agent::Instrumentation::ControllerInstrumentation

                def manipulate_with_newrelic(&block)
                  metrics = ["Custom/CarrierWave/Manipulate"]
                  self.class.trace_execution_scoped(metrics) do
                    manipulate_without_newrelic(&block)
                  end
                end

                alias :manipulate_without_newrelic :manipulate!
                alias :manipulate! :manipulate_with_newrelic

                add_method_tracer(:resize_image)
                add_method_tracer(:resize_to_limit)
                add_method_tracer(:resize_to_fill)

            end
        end
    end
end

DependencyDetection.defer do
    @name = :carrierwave_rmagick_image_processing

    depends_on do
        defined?(::CarrierWave::RMagick) &&
        !NewRelic::Control.instance['disable_carrierwave_image_processing'] &&
        ENV['NEWRELIC_ENABLE'].to_s !~ /false|off|no/i
    end

    executes do
        NewRelic::Agent.logger.debug 'Installing CarrierWave (RMagick) Image Processing Instrumentation'
    end

    executes do
        if defined?(::CarrierWave::Vips)
            ::CarrierWave::Vips.class_eval do
                include NewRelic::Agent::Instrumentation::ControllerInstrumentation

                def manipulate_with_newrelic(&block)
                  metrics = ["Custom/CarrierWave/Manipulate"]
                  self.class.trace_execution_scoped(metrics) do
                    manipulate_without_newrelic(&block)
                  end
                end

                alias :manipulate_without_newrelic :manipulate!
                alias :manipulate! :manipulate_with_newrelic

                add_method_tracer(:resize_image)
                add_method_tracer(:resize_to_limit)
                add_method_tracer(:resize_to_fill)

            end
        end
    end
end

DependencyDetection.defer do
    @name = :carrierwave_rmagick_image_processing

    depends_on do
        defined?(::CarrierWave::RMagick) &&
        !NewRelic::Control.instance['disable_carrierwave_image_processing'] &&
        ENV['NEWRELIC_ENABLE'].to_s !~ /false|off|no/i
    end

    executes do
        NewRelic::Agent.logger.debug 'Installing CarrierWave (RMagick) Image Processing Instrumentation'
    end

    executes do
        if defined?(::CarrierWave::RMagick)
            ::CarrierWave::RMagick.class_eval do
                include NewRelic::Agent::Instrumentation::ControllerInstrumentation

                def manipulate_with_newrelic(options = {}, &block)
                  metrics = ["Custom/CarrierWave/Manipulate"]
                  self.class.trace_execution_scoped(metrics) do
                    manipulate_without_newrelic(options, &block)
                  end
                end

                alias :manipulate_without_newrelic :manipulate!
                alias :manipulate! :manipulate_with_newrelic

                add_method_tracer(:resize_image)
                add_method_tracer(:resize_to_limit)
                add_method_tracer(:resize_to_fill)

            end
        end
    end
end

DependencyDetection.defer do
    @name = :carrierwave_mini_magick_image_processing

    depends_on do
        defined?(::CarrierWave::MiniMagick) &&
        !NewRelic::Control.instance['disable_carrierwave_image_processing'] &&
        ENV['NEWRELIC_ENABLE'].to_s !~ /false|off|no/i
    end

    executes do
        NewRelic::Agent.logger.debug 'Installing CarrierWave (MiniMagick) Image Processing Instrumentation'
    end

    executes do
        if defined?(::CarrierWave::MiniMagick)
            ::CarrierWave::RMagick.class_eval do
                include NewRelic::Agent::Instrumentation::ControllerInstrumentation

                def manipulate_with_newrelic(&block)
                  metrics = ["Custom/CarrierWave/Manipulate"]
                  self.class.trace_execution_scoped(metrics) do
                    manipulate_without_newrelic(options, &block)
                  end
                end

                alias :manipulate_without_newrelic :manipulate!
                alias :manipulate! :manipulate_with_newrelic

                add_method_tracer(:resize_image)
                add_method_tracer(:resize_to_limit)
                add_method_tracer(:resize_to_fill)

            end
        end
    end
end



