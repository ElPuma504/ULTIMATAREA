USE Northwind;

/*EJERCICIO 1 TRIGGERS*/
create trigger tr_Territories on Territories
after insert, update 
as
begin
	update Territories
	set TerritoryDescription=rtrim(i.TerritoryDescription)+'_try'
	from Territories t
	inner join inserted i on t.TerritoryID=i.TerritoryID
end
/*EJERCICIO 2 TRIGGERS*/
create trigger tr_CustomerDemographics on CustomerDemographics
after insert, update 
as
begin
	update CustomerDemographics
	set CustomerDesc=(i.CustomerDesc*0.25)+150
	from CustomerDemographics c
	inner join inserted i on c.CustomerTypeID=i.CustomerTypeID
end

select * from CustomerDemographics

/*EJERCICIO 3 TRIGGERS*/
create trigger tr_CustomerDemographics_Delete on CustomerDemographics
after insert, update 
as
begin
	print ('Registro Eliminado')
	select * from deleted
end

/*EJERCICIO 1 FUNCIONES*/
CREATE FUNCTION fn_employees(@anio int)
RETURNS TABLE AS RETURN (select * from  employees where YEAR(HireDate)=@anio)

select * from fn_employees(1992)

/*EJERCICIO 2 FUNCIONES*/
CREATE FUNCTION fn_Productos (@ProductID decimal(5,2))
RETURNS  decimal(5,2) AS
BEGIN
declare @UnitPrice  decimal(5,2)
   select @UnitPrice=UnitPrice*0.90 from Products where ProductID=@ProductID 
    RETURN @UnitPrice
END;

select dbo.fn_Productos(1)

/*EJERCICIO 3 FUNCIONES*/
CREATE FUNCTION fn_ordes_detalles(@OrderId int)
RETURNS TABLE AS RETURN (select  pr.ProductName, od.UnitPrice, od.Quantity, o.OrderDate, o.CustomerID from Orders o 
inner join [Order Details] od on o.OrderID=od.OrderID
inner join Products pr on pr.productID=od.ProductID
where o.OrderID=@OrderId)

select * from  fn_ordes_detalles(10250)

/*EJERCICIO 4 FUNCIONES*/
CREATE FUNCTION fn_Employees_BirthDate (@BirthDate datetime)
RETURNS varchar(20) AS
BEGIN
declare @Mes   varchar(20)
   select @Mes=DateName(MONTH,@BirthDate)
    RETURN @Mes
END;

select dbo.fn_Employees_BirthDate(BirthDate),*  from Employees

/*EJERCICIO 5 FUNCIONES*/
CREATE FUNCTION fn_ordes_cliente(@CustomerID nchar(5))
RETURNS TABLE AS RETURN (select top 100 * from Orders where CustomerID=@CustomerID order by OrderDate)

select * from  fn_ordes_cliente('VINET')