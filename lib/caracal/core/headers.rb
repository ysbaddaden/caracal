require 'caracal/core/models/header_model'
require 'caracal/errors'


module Caracal
  module Core

    # This module encapsulates all the functionality related to adding a page
    # header to the document.
    module Headers
      def self.included(base)
        base.class_eval do

          #-------------------------------------------------------------
          # Configuration
          #-------------------------------------------------------------

          const_set(:DEFAULT_HEADER_ALIGN, :center)

          attr_reader :header_align
          attr_reader :header_show
          attr_reader :header_contents
          attr_reader :header_relationships

          def header_relationships
            @header_relationships ||= []
          end

          def header_relationships=(relationships)
            @header_relationships = relationships
          end

          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------

          # This method controls whether and how page headers are displayed
          # on the document.
          def header(*args, &block)
            options = Caracal::Utilities.extract_options!(args)
            options.merge!({ show: !!args.first }) unless args.first.nil?  # careful: falsey value

            # copy page settings so TableModel can calculate width properly
            options[:width] = page_width
            options[:margin_left] = page_margin_left
            options[:margin_right] = page_margin_right

            model = Caracal::Core::Models::HeaderModel.new(options, &block)
            if model.valid?
              @header_align    = model.header_align
              @header_show     = model.header_show
              @header_contents = model.contents
            else
              raise Caracal::Errors::InvalidModelError, 'header :align parameter must be :left, :center, or :right'
            end
            model
          end
        end
      end
    end
  end
end
