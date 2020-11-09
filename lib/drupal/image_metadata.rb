module Contentful
  module Exporter
    module Drupal
      class ImageMetadata

        attr_reader :exporter, :config

        def initialize(exporter, config)
          @exporter, @config = exporter, config
        end

        def save_metadata_as_json
          exporter.create_directory("#{config.entries_dir}/image_metadata")
          config.db[:field_data_field_images].each do |img_row|
            extract_data(img_row)
          end
        end

        private

        def extract_data(img_row)
          puts "Saving image metadata - id: #{img_row[:entity_id]}_#{img_row[:field_images_fid]}"
          db_object = map_fields(img_row)
          exporter.write_json_to_file("#{config.entries_dir}/image_metadata/#{db_object[:id]}.json", db_object)
        end

        def map_fields(row, result = {})
          result[:id] = id(row[:entity_id], row[:field_images_fid])
          result[:entity_id] = row[:entity_id]
          result[:file_id] = row[:field_images_fid]
          result[:entity_type] = row[:entity_type]
          result[:bundle] = row[:entity_type]
          result[:img_alt_text] = row[:field_images_alt]
          result[:img_title] = row[:field_images_title]
          result[:img_width] = row[:field_images_width]
          result[:img_height] = row[:field_images_height]
          result
        end

        def id(entity_id, file_id)
          "img_metadata_#{entity_id}_#{file_id}"
        end

      end
    end
  end
end

