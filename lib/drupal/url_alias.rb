module Contentful
  module Exporter
    module Drupal
      class UrlAlias

        attr_reader :exporter, :config

        def initialize(exporter, config)
          @exporter, @config = exporter, config
        end

        def save_urls_as_json
          exporter.create_directory("#{config.entries_dir}/url_alias")
          config.db[:url_alias].each do |url_row|
            extract_data(url_row)
          end
        end

        private

        def extract_data(url_row)
          puts "Saving url - id: #{url_row[:pid]}"
          db_object = map_fields(url_row)
          exporter.write_json_to_file("#{config.entries_dir}/url_alias/#{db_object[:id]}.json", db_object)
        end

        def map_fields(row, result = {})
          result[:id] = id(row[:pid])
          result[:source] = row[:source]
          result[:alias] = row[:alias]
          result[:language] = row[:language]
          result
        end

        def id(tag_id)
          'url_alias_' + tag_id.to_s
        end

      end
    end
  end
end

