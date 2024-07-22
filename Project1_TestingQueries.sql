#Query 1: Top selling book
SELECT b.BookID,  b.Title, b.EditionNumber,  COUNT(o.OrderID) AS TotalOrders
FROM  Book b
JOIN BookOrder bo ON b.BookID = bo.BookID AND b.EditionNumber = bo.EditionNumber
JOIN `Order` o ON bo.OrderID = o.OrderID
GROUP BY b.BookID, b.Title, b.EditionNumber
ORDER BY TotalOrders DESC
LIMIT 1;

#Query 2: Employees with highest salary in each department
SELECT EmployeeID, EmployeeFirstName, EmployeeLastName, DepartmentName, AnnualSalary
FROM Employee
JOIN (
    SELECT DepartmentID, MAX(AnnualSalary) AS MaxSalary
    FROM Employee
    JOIN OfficeDepartment USING (EmployeeID)
    GROUP BY DepartmentID
) AS MaxSalaries
ON Employee.AnnualSalary = MaxSalaries.MaxSalary
JOIN Department USING (DepartmentID);

#Query 3: Total number of books ordered by each institution
SELECT i.InstitutionName, COUNT(bo.BookID) AS TotalBooksOrdered
FROM Institution i
JOIN Customer c ON i.CustomerID = c.CustomerID
JOIN `Order` o ON c.CustomerID = o.CustomerID
JOIN BookOrder bo ON o.OrderID = bo.OrderID
GROUP BY i.InstitutionName;

#Query 4: List of books ordered by XYZ college :
SELECT BookID, EditionNumber, Title
FROM Book
JOIN Ebook USING (BookID, EditionNumber)
JOIN StudentEbook USING (BookID, EditionNumber)
JOIN StudentAccount USING (StudentAccountNumber)
WHERE CustomerID IN (SELECT CustomerID FROM Institution WHERE InstitutionID = 5002);

#Query 5: Top 3 individual customers by total order amount
SELECT c.CustomerID, i.IndividualFirstName, i.IndividualLastName, SUM(b.Price * bo.Quantity) AS TotalOrderAmount
FROM Customer c
JOIN `Order` o ON c.CustomerID = o.CustomerID
JOIN BookOrder bo ON o.OrderID = bo.OrderID
JOIN Book b ON bo.BookID = b.BookID AND bo.EditionNumber = b.EditionNumber
JOIN Individual i ON c.CustomerID = i.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalOrderAmount DESC
LIMIT 3;





