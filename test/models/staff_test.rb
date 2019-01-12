require 'test_helper'

class StaffTest < ActiveSupport::TestCase
  test 'count' do
    assert_equal 12, Staff.count
  end

  test "eng5 joe's reporter is lead2 joe" do
    assert_equal 'lead2 joe', staffs(:eng5_joe).reporter.name
  end

  test "bossman has no reporter" do
    assert_nil staffs(:boss_joe).reporter
  end

  test "lead1 joe has 3 reportees" do
    assert_equal ['eng1 joe', 'eng2 joe', 'eng3 joe'], staffs(:lead1_joe).reportees.pluck(:name)
  end

  test "engineer joes have no reportees" do
    %w(eng1_joe eng2_joe eng3_joe eng4_joe eng5_joe).each do |eng|
      assert staffs(eng).reportees.empty?
    end
  end

  test "eng5_joe's superiors are lead2, manager1 and boss joes" do
    assert_equal ['lead2 joe', 'manager1 joe', 'boss joe'], staffs(:eng5_joe).superiors.pluck(:name)
  end

  test "bossman has no superiors" do
    assert staffs(:boss_joe).superiors.empty?
  end

  test "manager2_joe's subordinates are lead3 and lead4 joes" do
    assert_equal ['lead3 joe', 'lead4 joe'], staffs(:manager2_joe).subordinates.pluck(:name)
  end

  test "bossman's subordinates are all of them" do
    assert_equal ["eng1 joe", "eng2 joe", "eng3 joe", "lead1 joe", "eng4 joe", "eng5 joe", "lead2 joe", "manager1 joe", "lead3 joe", "lead4 joe", "manager2 joe"], staffs(:boss_joe).subordinates.pluck(:name)
  end

  test "engineer joes have no subordinates" do
    %w(eng1_joe eng2_joe eng3_joe eng4_joe eng5_joe).each do |eng|
      assert staffs(eng).subordinates.empty?
    end
  end

  test "top10" do
    assert_equal 350, Staff.top10_with_salary_ratio
  end
end
