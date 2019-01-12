# Readme

---

## Problem

A company has various roles.

* boss
* manager
* lead
* engineer

Boss doesn’t report to anybody.
Apart from Boss every other employee reports to someone else. 
Engineer is not allowed to have reportee under them. 
Apart from Engineer role every other role can have multiple reportee. 

## Tasks
* Create a rest endpoint to print hierarchy given any position in the above mentioned organization (Direction: bottom to top).
* Top 10 employees with ratio of salary 
* Delete an employee from the company. Before deleting though, assign his reporter as reporter for all of his reportees.

---

## Possible Design
### Attrs
* id
* name
* role in (bossman, manager, lead, engineer)
* reporter_id

### Relations
1 employee has_one reporter (but ceo has no reporter)
1 employee has_many reportees (but engineers have no reportees)

### Testcases
* x.reporter
* x.reportees
* x.superiors and x.subordinates
* ceo.reporter.nil? == true
* (roles - ceo).each { |role| role.reporter.present? == true }
* sde.reportees.empty? == true
* (roles - sde).each { |role| role.reportees.present? == true }

```
boss Joe, 120, 60%
manager Joe, 40, 20%
lead Joe, 30, 15%
eng Joe, 10, 5%
```

