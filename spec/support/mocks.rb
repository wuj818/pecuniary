module Mocks
  def mock_relation(stubs = {})
    @mock_relation ||= double(ActiveRecord::Relation, stubs).as_null_object
  end
end
