module ID3Tag
  class Configuration
    include Singleton
    ResetError = Class.new(StandardError)
    StackItem = Struct.new(:configuration)

    class << self
      def local_configuration(&blk)
        instance.send(:local_configuration, &blk)
      end

      def configuration
        value_from_stack = instance.instance_variable_get(:@stack).last
        value = value_from_stack && value_from_stack.configuration
        value ||= instance.instance_variable_get(:@global_configuration)
        yield value if block_given?
        value
      end

      def reset
        instance.send(:reset)
      end
    end

    def local_configuration
      instance_to_copy = @stack.last && @stack.last.configuration
      instance_to_copy ||= @global_configuration
      stack_item = StackItem.new(instance_to_copy.dup)
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
