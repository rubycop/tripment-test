module DataFormatter
    extend ActiveSupport::Concern

    def prepare_data(arr)
        arr.map{|el| { name: el, created_at: Time.now, updated_at: Time.now }}
    end
end