module ESP
  class Report < ESP::Resource
    ##
    # The organization the report belongs to.
    belongs_to :organization, class_name: 'ESP::Organization'

    ##
    # The sub_organization the report belongs to.
    belongs_to :sub_organization, class_name: 'ESP::SubOrganization'

    ##
    # The team the report belongs to.
    belongs_to :team, class_name: 'ESP::Team'

    # Not Implemented. You cannot create or update a Report.
    def update
      fail ESP::NotImplementedError
    end

    # Not Implemented. You cannot destroy a Report.
    def destroy
      fail ESP::NotImplementedError
    end

    # Enqueue a report to be run for the given team.
    # Returns a Report object with a status of 'queued' and an id
    # ==== Attribute
    #
    # +team_id+ - The team to create the report for.
    #
    # Periodically check the API
    #   ESP::Report.find(<id>)
    # until status is 'complete'.
    #
    # If not successful, returns a Report object with the errors object populated.
    def self.create(arguments = {})
      fail ArgumentError, "You must supply a team id." unless arguments.with_indifferent_access[:team_id].present?
      super
    end

    # Returns a paginated collection of alerts for the report
    #
    # ==== Attributes
    #
    # * +arguments+ - An optional hash of search criteria to filter the returned collection.
    # Valid arguments are
    # * +region_id+ - Return only alerts for this region.
    # * +status+ - Return only alerts for the give status(es).  Valid values are fail, warn, error, pass, info
    # * +first_seen+ - Return only alerts first seen after this time.  Format: "2015-10-15 10:29:45"
    # * +suppressed+ - Return only suppressed alerts
    # * +team_id+ - Return only alerts for the given team.
    # * +external_account_id+ - Return only alerts for the given external id.
    # * +service_id+ - Return only alerts on signatures with the given service.
    # * +signature_severity+ - Return only alerts for signatures with the given risk_level.  Valid values are Low, Medium, High
    # * +signature_name+ - Return only alerts for signatures with hte given name.
    # * +resource+ - Return only alerts for the given resource or tag.
    # * +signature_identifier+ - Return only alerts for signatures with the given identifier.
    #
    # ==== Example
    #
    #   report = ESP::Report.find(345)
    #   alerts = report.alerts(status: 'fail', signature_severity: 'High')
    def alerts(arguments = {})
      ESP::Alert.for_report(id, arguments)
    end

    # Returns the stats for this report
    def stat
      Stat.for_report(id)
    end
  end
end
