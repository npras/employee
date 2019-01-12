class Staff < ApplicationRecord

  has_many :reportees, class_name: 'Staff', foreign_key: :reporter_id
  belongs_to :reporter, class_name: 'Staff', foreign_key: :reporter_id

  #def reporter
    #Staff.find_by(id: reporter_id)
  #end

  def superiors
    [reporter].compact.map do |reportr|
      [reportr] + reportr.superiors
    end.flatten
  end

  #def superiors
    #current_reporter = reporter
    #result = []
    #loop do
      #break if current_reporter.nil?
      #result << current_reporter
      #current_reporter = current_reporter.reporter
    #end
    #result
  #end

  def subordinates
    reportees.map do |reportee|
      reportee.subordinates + [reportee]
    end.flatten
  end

  def self.top10_with_salary_ratio
    #Staff.order(salary: :desc).limit(10).pluck(:salary).sum
    top10 = order(salary: :desc).limit(10).to_a
    top10_total = top10.map(&:salary).sum
    top10.map {|r| r.salary*100/top10_total.to_f}
  end
end
