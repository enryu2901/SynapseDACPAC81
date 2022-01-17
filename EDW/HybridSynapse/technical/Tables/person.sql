CREATE TABLE [technical].[person] (
    [id]         INT           NULL,
    [name] VARCHAR (100) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

