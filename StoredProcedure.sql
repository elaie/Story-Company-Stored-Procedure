CREATE PROCEDURE ProcessSale
    @item_id INT,
    @quantity_sold INT
AS
BEGIN
    DECLARE @current_stock INT;
    DECLARE @price DECIMAL(10, 2);
    DECLARE @status NVARCHAR(20);
    DECLARE @total_amount DECIMAL(10, 2);

    -- Check current stock
    SELECT 
        @current_stock = quantity_in_stock,
        @price = price
    FROM items
    WHERE item_id = @item_id;

    -- If item not found
    IF @current_stock IS NULL
    BEGIN
        RAISERROR('Item not found.', 16, 1);
        RETURN;
    END

    -- If sufficient stock
    IF @current_stock >= @quantity_sold
    BEGIN
        -- Update stock quantity
        UPDATE items
        SET quantity_in_stock = quantity_in_stock - @quantity_sold
        WHERE item_id = @item_id;

        -- Calculate total
        SET @total_amount = @price * @quantity_sold;

        -- Insert sale record
        INSERT INTO sales (item_id, quantity_sold, total_amount)
        VALUES (@item_id, @quantity_sold, @total_amount);

        -- Re-check stock for status update
        SELECT @current_stock = quantity_in_stock FROM items WHERE item_id = @item_id;

        IF @current_stock = 0
            SET @status = 'sold out';
        ELSE IF @current_stock < 10
            SET @status = 'low stock';
        ELSE
            SET @status = 'available';

        UPDATE items SET status = @status WHERE item_id = @item_id;

        -- Notify if low stock
        IF @status = 'low stock'
        BEGIN
            PRINT 'Stock is low. Please consider replenishing the item.';
        END
    END
    ELSE
    BEGIN
        RAISERROR('Insufficient stock. Sale not processed.', 16, 1);
    END
END