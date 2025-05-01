create table kapps_db.accounts_resets
(id int primary key auto_increment,
user_id int,
codico varchar(12),
estado int default 1,
fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
fecha_uso timestamp);
