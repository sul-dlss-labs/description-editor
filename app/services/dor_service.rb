# frozen_string_literal: true

# Service for interacting with DOR Services App
class DorService
  def self.load(identifier, overwrite: false)
    new.load(identifier, overwrite: overwrite)
  end

  def self.update(description)
    new.update(description)
  end

  # Load a Cocina description from DSA and creates an ActiveRecord Description
  # @return [Description]
  # @raise [Dor::Services::Client::NotFoundResponse]
  # @raise [Dor::Services::Client::UnexpectedResponse]
  def load(identifier, overwrite:)
    cocina_obj = dor_client.object(identifier).find

    Description.destroy_by(external_identifier: identifier) if overwrite
    Description.create(cocina_obj.description.to_h.except(:relatedResource).merge(external_identifier: identifier))
  end

  def update(description)
    cocina_obj = dor_client.object(description.external_identifier).find
    new_cocina_object = cocina_obj.new(description: merge_description(description, cocina_obj.description))
    dor_client.object(description.external_identifier).update(params: new_cocina_object)
  end

  private

  def dor_client
    @dor_client ||= Dor::Services::Client.configure(url: Settings.dor_services.url,
                                                    token: Settings.dor_services.token)
  end

  def merge_description(description, cocina_description)
    # Until implementation is complete, performing selected merge.
    cocina_description.new(
      title: description.title
    )
  end
end
