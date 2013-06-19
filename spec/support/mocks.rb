module Mocks
  def mock_relation(stubs = {})
    @mock_relation ||= mock(ActiveRecord::Relation, stubs).as_null_object
  end
end
