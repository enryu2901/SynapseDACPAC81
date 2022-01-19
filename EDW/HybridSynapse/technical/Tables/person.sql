CREATE TABLE [technical].[person] (
    [id]   INT           NULL,
    first_name VARCHAR (100) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);









