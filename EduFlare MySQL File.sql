use eduflare;

#Find courses whose duration is more than 50 minutes
SELECT course_name, duration_mins 
FROM course
WHERE duration_mins > 50;

#Find instructors with only bachelor’s degree and rating lower than 5
SELECT instructor_id, firstname, lastname
FROM instructor
WHERE degree = "Bachelor's" AND rating < 5;

#Select count of courses of every category
SELECT category, count(course_no) as no_of_courses
FROM course
GROUP BY category;

#Correlated query 
#Find the names of all the courses that have atleast 2 purchases 
SELECT c.product_id, c.course_no, c.course_name
FROM course c
WHERE 3 < ( SELECT count(*)
                       FROM course c INNER JOIN invoice_items iv 
                       ON c.product_id = iv.item_no );

#Aggregate Query
#Find the sales of the courses for every month of last year
SELECT c.course_name, i.month, sum(i.amount) AS total_sales
FROM invoice i inner join product p inner join course c 
ON i.inv_no = p.inv_no AND p.product_id = c.product_id
GROUP BY c.course_name, i.month
ORDER BY total_sales DESC, i.month; 


#Nested Query 
#Find the instructor that can teach both course No. 12 Data Mining and course No. 29 Marketing Analytics.
SELECT i.instructor_id, i.firstname, i.lastname 
FROM instructor i 
WHERE i.instructor_id IN (SELECT c.instructor_id 
                                         FROM course c inner join instructor i 
                                         ON c.instructor_id = i.instructor_id
                                         WHERE c.course_no = 12 )
	AND i.instructor_id IN (SELECT c.instructor_id 
                                         FROM course c inner join instructor i
                                         ON c.instructor_id = i.instructor_id
                                         WHERE c.course_no = 29 );

#(>ANY) Find the names of learners who have enrolled in courses that have more than 2 learners enrolled in it.
    
    SELECT DISTINCT learners.first_name, learners.last_name
FROM learners
JOIN enrollment ON learners.learner_id = enrollment.learner_id
JOIN (
  SELECT product_id, COUNT(DISTINCT learner_id) AS num_learners
  FROM enrollment
  GROUP BY product_id
  HAVING COUNT(DISTINCT learner_id) > ANY (
    SELECT COUNT(DISTINCT learner_id)
    FROM enrollment
    GROUP BY product_id
    HAVING COUNT(DISTINCT learner_id) > 2
  )
) AS popular_courses ON enrollment.product_id = popular_courses.product_id
WHERE learners.first_name IS NOT NULL;
   
#(EXISTS, NOT EXISTS) 
#find all courses that have no active enrollments
SELECT product_id, course_name
FROM course
WHERE NOT EXISTS (
  SELECT product_id
  FROM enrollment
  WHERE enrollment.product_id = course.product_id
);



#(Subqueries in Select and From) Find the course number, name and total ordered quantity of each course , even if it has no purchases.
SELECT c.course_name, ( SELECT COUNT(iv.item_no) FROM invoice_items iv WHERE c.product_id = iv.item_no) AS total_ordered  
FROM course c
GROUP BY c.course_name, total_ordered
ORDER BY total_ordered DESC;


#(Set Operations (UNION))
#Find the learner names who are from USC or who have enrolled in product_id 114 Marketing analytics
SELECT l.learner_id, l.first_name, l.last_name 
FROM learners l INNER JOIN student s INNER JOIN university u
ON l.learner_id = s.learner_id AND s.uni_id = u.uni_id
WHERE u.uni_name IN ('University of Southern California')
UNION 
SELECT l.learner_id, l.first_name, l.last_name 
FROM learners l INNER JOIN enrollment e 
ON l.learner_id = e.learner_id
WHERE e.product_id = 114;



    
