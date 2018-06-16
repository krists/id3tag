module ID3Tag
  class Configuration
    ResetError = Class.new(StandardError)
    include Singleton
    StackItem = Struct.new(:configuration)

    class << self
      def local_configuration(&blk)
        instance.send(:local_configuration, &blk)
      end

      def configuration
        value = instance.instance_variable_get(:@stack).last&.configuration || instance.instance_variable_get(:@global_configuration)
        yield value if block_given?
        value
      end

      def reset
        instance.send(:reset)
      end
    end

    def local_configuration
      stack_item = StackItem.new((@stack.last&.configuration || @global_configuration).dup)
      stack_backup = @stack.dup
      @stack << stack_item
      begin
        yield stack_item.configuration
      ensure
        @stack.replace stack_backup
      end
    end

    private

    def initialize
      @stack = []
      reset
    end

    def reset
      raise ResetError, "Configuration cannot be reset within local_configuration block" if @stack.size > 0
      @global_configuration = ConfigurationStruct.new
    end
  end
end
