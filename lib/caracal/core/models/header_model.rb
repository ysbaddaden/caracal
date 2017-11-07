require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models

      # This class handles block options passed to the header method.
      class HeaderModel < BaseModel

        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------

        # constants
        const_set(:DEFAULT_HEADER_ALIGN, :center)
        const_set(:DEFAULT_HEADER_SHOW,  false)

        # accessors
        attr_reader :header_align
        attr_reader :header_show
        attr_reader :page_width
        attr_reader :page_margin_left
        attr_reader :page_margin_right

        # initialization
        def initialize(options={}, &block)
          @header_align  = DEFAULT_HEADER_ALIGN
          @header_show   = DEFAULT_HEADER_SHOW

          if content = options.delete(:content)
            p content, options.dup, &block
          end

          super options, &block
        end


        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------
        #
        #=============== DATA ACCESSORS =======================

        def contents
          @contents ||= []
        end


        #=============== SETTERS ==============================

        def align(value)
          @header_align = value.to_s.to_sym
        end

        def show(value)
          @header_show = !!value
        end

        #=============== SETTERS ==============================

        # integers
        [:width, :margin_left, :margin_right].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@page_#{ m }", value.to_i)
          end
        end

        #=============== VALIDATION ===========================

        def valid?
          (!header_show || [:left, :center, :right].include?(header_align))
        end


        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private

        def option_keys
          [:align, :content, :show, :width, :margin_left, :margin_right]
        end
      end
    end
  end
end
