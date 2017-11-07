require 'delegate'
require 'nokogiri'

require 'caracal/renderers/xml_renderer'


module Caracal
  module Renderers
    class HeaderRenderer < DocumentRenderer
      # :nodoc:
      class DocumentDecorator < SimpleDelegator
        # We decorate the document to catch relationships, since they are
        # related to the header not the document.

        include Caracal::Core::Relationships

        def initialize(doc)
          doc.header_relationships = relationships
          super doc
        end
      end

      # This method instantiates a new verison of this renderer.
      #
      def initialize(doc)
        unless doc.is_a?(Caracal::Document)
          raise NoDocumentError, 'renderers must receive a reference to a valid Caracal document object.'
        end

        @document = DocumentDecorator.new(doc)
      end


      #-------------------------------------------------------------
      # Public Methods
      #-------------------------------------------------------------

      # This method produces the xml required for the `word/settings.xml`
      # sub-document.

      def to_xml
        builder = ::Nokogiri::XML::Builder.with(declaration_xml) do |xml|
          xml['w'].hdr root_options do
            document.header_contents.each do |m|
              method = render_method_for_model(m)
              send(method, xml, m)
            end
          end
        end
        builder.to_xml(save_options)
      end

      #-------------------------------------------------------------
      # Private Methods
      #-------------------------------------------------------------
      private

      def root_options
        {
          'xmlns:mc'  => 'http://schemas.openxmlformats.org/markup-compatibility/2006',
          'xmlns:o'   => 'urn:schemas-microsoft-com:office:office',
          'xmlns:r'   => 'http://schemas.openxmlformats.org/officeDocument/2006/relationships',
          'xmlns:m'   => 'http://schemas.openxmlformats.org/officeDocument/2006/math',
          'xmlns:v'   => 'urn:schemas-microsoft-com:vml',
          'xmlns:wp'  => 'http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing',
          'xmlns:w10' => 'urn:schemas-microsoft-com:office:word',
          'xmlns:w'   => 'http://schemas.openxmlformats.org/wordprocessingml/2006/main',
          'xmlns:wne' => 'http://schemas.microsoft.com/office/word/2006/wordml',
          'xmlns:sl'  => 'http://schemas.openxmlformats.org/schemaLibrary/2006/main',
          'xmlns:a'   => 'http://schemas.openxmlformats.org/drawingml/2006/main',
          'xmlns:pic' => 'http://schemas.openxmlformats.org/drawingml/2006/picture',
          'xmlns:c'   => 'http://schemas.openxmlformats.org/drawingml/2006/chart',
          'xmlns:lc'  => 'http://schemas.openxmlformats.org/drawingml/2006/lockedCanvas',
          'xmlns:dgm' => 'http://schemas.openxmlformats.org/drawingml/2006/diagram'
        }
      end

    end
  end
end

