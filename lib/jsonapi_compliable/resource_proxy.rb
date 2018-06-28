module JsonapiCompliable
  class ResourceProxy
    include Enumerable

    attr_reader :resource, :query, :scope

    def initialize(resource, scope, query, single: false, raise_on_missing: false)
      @resource = resource
      @scope = scope
      @query = query
    end

    def single?
      !!@single
    end

    def raise_on_missing?
      !!@raise_on_missing
    end

    def data
      to_a
    end

    def to_a
      records = @scope.resolve
      if records.empty? && raise_on_missing?
        raise JsonapiCompliable::Errors::RecordNotFound
      end
      records = records[0] if single?
      records
    end

    def each(&blk)
      to_a.each(&blk)
    end

    def stats
      @stats ||= @scope.resolve_stats
    end
  end
end