module WebServices
    class GbfsService
        def get_data
            connect
            return nil if error?
            puts "[GbfsService] status=200"
            parse_body_as_json
        end

        private 

        def connect
            @response = Faraday.get gbfs_api_url
        end

        def error?
            @response.status != 200
        end

        def gbfs_api_url
            raise NotImplementedError
        end

        def parse_body_as_json
            JSON.parse(@response.body).with_indifferent_access
        end
    end
end