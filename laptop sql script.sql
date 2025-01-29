SELECT * FROM mydb.laptop_backup;

use mydb;

create table laptop like laptop_backup;

insert into laptop
select * from laptop_backup;

select `Unnamed: 0` from laptop_backup
where Company is null and TypeName is null and Inches is null
and ScreenResolution is null and Cpu is null and Ram is null
and Memory is null and Gpu is null and OpSys is null and Weight is null and Price is null;

select count(*) from laptop_backup;

alter table laptop_backup modify column Inches decimal(10,1);
SET SQL_SAFE_UPDATES = 0;

WITH updated_ram AS (
    SELECT `Unnamed: 0`, REPLACE(Ram, 'GB', '') AS new_Ram
    FROM laptop_backup
)
UPDATE laptop_backup l1
JOIN updated_ram t
ON l1.`Unnamed: 0` = t.`Unnamed: 0`
SET l1.Ram = t.new_Ram;

alter table laptop_backup modify column Ram integer;

WITH updated_Weight AS (
    SELECT `Unnamed: 0`, REPLACE(Weight, 'kg', '') AS new_Weight
    FROM laptop_backup
)
UPDATE laptop_backup l1
JOIN updated_Weight t
ON l1.`Unnamed: 0` = t.`Unnamed: 0`
SET l1.Weight = t.new_Weight;

select * from laptop_backup;

SELECT `Weight`
FROM laptop_backup
WHERE `Weight` NOT REGEXP '^[0-9]*\.?[0-9]+$' OR `Weight` IS NULL OR `Weight` = '';

UPDATE laptop_backup
SET Weight = 0
WHERE `Weight` NOT REGEXP '^[0-9]*\.?[0-9]+$' OR `Weight` IS NULL OR `Weight` = '';

ALTER TABLE laptop_backup 
MODIFY COLUMN Weight DECIMAL(10,1) DEFAULT 0;

DESCRIBE laptop_backup;

WITH rounded_prices AS (
    SELECT `Unnamed: 0`, ROUND(Price) AS RoundedPrice
    FROM laptop_backup
)
UPDATE laptop_backup l1
INNER JOIN rounded_prices r
ON l1.`Unnamed: 0` = r.`Unnamed: 0`
SET l1.Price = r.RoundedPrice;

ALTER TABLE laptop_backup 
MODIFY COLUMN Price integer;

update laptop_backup
set OpSys = case
	when OpSys like '%mac%' then 'macos'
    when OpSys like 'windows%' then 'windows'
    when OpSys like '%linux%' then 'macos'
    when OpSys = 'No OS' then 'N/A'
	else 'other'
end;    

alter table laptop_backup
add column gpu_brand varchar(255) after Gpu,
add column gpu_name varchar(255) after gpu_brand;

WITH GpuBrandCTE AS (
    SELECT `Unnamed: 0`, SUBSTRING_INDEX(Gpu, ' ', 1) AS GpuBrand
    FROM laptop_backup
)
UPDATE laptop_backup l1
INNER JOIN GpuBrandCTE g
ON l1.`Unnamed: 0` = g.`Unnamed: 0`
SET l1.gpu_brand = g.GpuBrand;

UPDATE laptop_backup l1
INNER JOIN laptop_backup l2
ON l2.`Unnamed: 0` = l1.`Unnamed: 0`
SET l1.gpu_name = REPLACE(l2.Gpu, l1.gpu_brand, '');

alter table laptop_backup drop column Gpu;


alter table laptop_backup
add column cpu_brand varchar(255) after Cpu,
add column cpu_name varchar(255) after cpu_brand,
add column cpu_speed varchar(255) after cpu_name;

WITH cpuBrandCTE AS (
    SELECT `Unnamed: 0`, SUBSTRING_INDEX(Cpu, ' ', 1) AS CpuBrand
    FROM laptop_backup
)
UPDATE laptop_backup l1
INNER JOIN cpuBrandCTE g
ON l1.`Unnamed: 0` = g.`Unnamed: 0`
SET l1.cpu_brand = g.CpuBrand;

UPDATE laptop_backup l1
INNER JOIN laptop_backup l2
ON l2.`Unnamed: 0` = l1.`Unnamed: 0`
SET l1.cpu_speed = CAST(REPLACE(SUBSTRING_INDEX(l2.Cpu,' ', -1), 'GHz', '') AS DECIMAL(10,2));


UPDATE laptop_backup l1
INNER JOIN laptop_backup l2
ON l2.`Unnamed: 0` = l1.`Unnamed: 0`
SET l1.cpu_name = REPLACE(REPLACE(l2.Cpu, l1.cpu_brand, ''), SUBSTRING_INDEX(REPLACE(l2.Cpu, l1.cpu_brand, ''), ' ', -1), '');


alter table laptop_backup drop column Cpu;

alter table laptop_backup
add column resolution_width integer after ScreenResolution,
add column resolution_height integer after resolution_width;

SET SQL_SAFE_UPDATES = 0;

UPDATE laptop_backup
SET resolution_width = 
    CASE
        WHEN ScreenResolution REGEXP '[0-9]+x[0-9]+' THEN 
            CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution, 'x', 1), ' ', -1) AS UNSIGNED)
        ELSE NULL
    END;

UPDATE laptop_backup
SET resolution_height = 
    CASE
        WHEN ScreenResolution REGEXP '[0-9]+x[0-9]+' THEN 
            CAST(SUBSTRING_INDEX(ScreenResolution, 'x', -1) AS UNSIGNED)
        ELSE NULL
    END;
    

    
alter table laptop_backup
add column touchscreen integer after resolution_height;

select ScreenResolution like '%Touch%' from laptop_backup;

update laptop_backup
set touchscreen = ScreenResolution like '%Touch%';

alter table laptop_backup 
drop column ScreenResolution;

update laptop_backup
set cpu_name = substring_index(TRIM(cpu_name),' ',2);

alter table laptop_backup
add column memory_type varchar(255) after Memory,
add column primary_storage varchar(255) after memory_type,
add column secondary_storage varchar(255) after primary_storage;

update laptop_backup
set memory_type =case
					when Memory like '%SSD%' and Memory like '%HDD%' then 'Hybrid'
					when Memory like '%SSD%'  then 'SSD'
                    when Memory like  '%HDD%' then 'HDD'
                    when Memory like '%Flash Storage%'  then 'Flash Storage'
                    when Memory like '%Hybrid%'  then 'Hybrid'
                    when Memory like '%Flash Storage%' and Memory like '%HDD%' then 'Hybrid'
					else null
                 end;   
                    
update laptop_backup
set primary_storage = REGEXP_SUBSTR(substring_index(Memory,'+',1),'[0-9]+'),
secondary_storage = CASE WHEN Memory LIKE '%+%' THEN REGEXP_SUBSTR(substring_index(Memory,'+',-1),'[0-9]+') else 0 end;


update laptop_backup
set primary_storage = CASE when primary_storage <= 2 THEN primary_storage*1024 else primary_storage end,
secondary_storage = CASE when secondary_storage <= 2 THEN secondary_storage*1024 else secondary_storage end;

alter table laptop_backup drop column Memory;

alter table laptop_backup drop column gpu_name;

select * from laptop_backup















