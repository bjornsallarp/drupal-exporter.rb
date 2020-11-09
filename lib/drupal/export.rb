require 'fileutils'
require 'json'
require 'yaml'

require_relative 'tag'
require_relative 'vocabulary'
require_relative 'user'
require_relative 'content_type'
require_relative 'file_managed'
require_relative 'url_alias'
require_relative 'image_metadata'

module Contentful
  module Exporter
    module Drupal
      class Export

        attr_reader :config, :boolean_columns

        def initialize(settings)
          @config = settings
          @boolean_columns = []
        end

        def save_data_as_json
          boolean_columns << YAML.load_file(config.config['drupal_boolean_columns']) if config.config['drupal_boolean_columns']
          content_types
          image_metadata
          urls
          tags
          vocabularies
          users
          files
        end

        def write_json_to_file(path, data)
          File.open(path, 'w') do |file|
            file.write(JSON.pretty_generate(data))
          end
        end

        def create_directory(path)
          FileUtils.mkdir_p(path) unless File.directory?(path)
        end

        private

        def urls
          UrlAlias.new(self, config).save_urls_as_json
        end

        def tags
          Tag.new(self, config).save_tags_as_json
        end

        def vocabularies
          Vocabulary.new(self, config).save_vocabularies_as_json
        end

        def users
          User.new(self, config).save_users_as_json
        end

        def files
          FileManaged.new(self, config).save_files_as_json
        end

        def image_metadata
          ImageMetadata.new(self, config).save_metadata_as_json
        end

        def content_types
          config.drupal_content_types.each do |content_type, schema|
            ContentType.new(self, config, content_type, schema).save_content_types_as_json
          end
        end

      end
    end
  end
end