module PaginationHelper
    extend ActiveSupport::Concern  
    def paginate(collection, page:, per_page: 20)
      paginated = collection.offset((page - 1) * per_page).limit(per_page)
      has_more = collection.count > page * per_page  
      [paginated,has_more]
    end
end
