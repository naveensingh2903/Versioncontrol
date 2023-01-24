CREATE TABLE [dbo].[product_audits] (
    [change_id]    INT             IDENTITY (1, 1) NOT NULL,
    [product_id]   INT             NOT NULL,
    [product_name] VARCHAR (255)   NOT NULL,
    [brand_id]     INT             NOT NULL,
    [category_id]  INT             NOT NULL,
    [model_year]   SMALLINT        NOT NULL,
    [list_price]   DECIMAL (10, 2) NOT NULL,
    [updated_at]   DATETIME        NOT NULL,
    [operation]    CHAR (3)        NOT NULL,
    PRIMARY KEY CLUSTERED ([change_id] ASC),
    CHECK ([operation]='INS' OR [operation]='DEL')
);


GO
CREATE TRIGGER trg_product_audit
ON product_audits
AFTER INSERT, delete
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO product_audits(
        product_id, 
        product_name,
        brand_id,
        category_id,
        model_year,
        list_price, 
        updated_at, 
        operation
    )
    SELECT
        i.product_id,
        product_name,
        brand_id,
        category_id,
        model_year,
        i.list_price,
        GETDATE(),
        'INS'
    FROM
        inserted i
    UNION ALL
    SELECT
        d.product_id,
        product_name,
        brand_id,
        category_id,
        model_year,
        d.list_price,
        GETDATE(),
        'DEL'
    FROM
        deleted d;
END
