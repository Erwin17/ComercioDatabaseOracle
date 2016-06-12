create table direccion(
id 			number 			not null,
ciudad 		varchar2(100) 	not null,
estado 		varchar2(100) 	not null,
municipio 	varchar2(100) 	not null,
direccion 	varchar2(500)	not null,
direccion2	varchar2(500),				
cod_postal 	varchar2(5)		not null
);
--Secuenia
--drop sequence direccion_sequence;
create sequence direccion_sequence start with 1;
--Primary Key
alter table direccion add constraint direccion_id_pk primary key(id) using index;



create table usuario(
id 				    number 					                not null,
id_direccion 	  	number 					                not null,
nombre 			    varchar2(30) 			                not null,
apellido 		    varchar2(30) 			                not null,
email 			    varchar2(100) 			              	not null,
password 	    	varchar(100) 			                not null,
telefono1	    	varchar(12)				                not null,
telefono2		    varchar(12),
fecha_registro		date		        default sysdate		not null, 
activo 				number(1)			default 1
);

--Secuencia
drop sequence usuario_sequence;
create sequence usuario_sequence start with 1;
--Primary Key
alter table usuario add constraint usuario_id_pk primary key (id) using index;
--Index (Email)
alter table usuario add constraint email_uq unique (email) using index;
--Foreign KEY (Direccion)
alter table usuario add constraint id_direccion_fk foreign key (id_direccion) references direccion (id);



create table representante(
id 				number 							not null,
nombre 			varchar2(30) 					not null,
apellido 		varchar2(30) 					not null,
email 			varchar2(100) 					not null,
telefono1		varchar(12)						not null,
telefono2		varchar(12),
fecha_registro	date		default sysdate		not null
)
--Secuencia
create sequence representante_sequence start with 1;
--Primary key
alter table representante add constraint representante_id_pk primary key (id) using index;
--Valor Unico
alter table representante add constraint representante_email_uq unique(email) using index;



create table proveedor(
id 					number 								not null,
id_direccion		number								not null,
company				varchar2(150)						not null,
rif					varchar2(20)						not null,
telefono1			varchar2(12)						not null,
telefono2			varchar2(12),
email				varchar2(100)						not null,

fecha_registro		date			DEFAULT sysdate		not null
);

--Secuencia
create sequence proveedor_sequence start with 1;
--Primary key
alter table proveedor add constraint proIdPk primary key (id) using index;
--Nombre Compañia Unico
alter table proveedor add constraint proCompanyRifUq unique(company, rif) using index;
--Email Unico
alter table proveedor add constraint proEmailUq unique(email) using index;
--Foreign Key (Direccion)
alter table proveedor add constraint proIdDireccion_fk foreign key (id_direccion) references direccion (id);
--Foreign Key (Representante)
alter table proveedor add constraint proIdRepresentante_fk foreign key (id_representante) references representante (id);


create table proveedor_representante(
id_proveedor number (38) not null,
id_representante number(38) not null
);
alter table proveedor_representante add constraint primary key (id_proveedor, id_representante) using index;
alter table proveedor_representante add constraint idpropk foreign key (id_proveedor) references proveedor (id);
alter table proveedor_representante add constraint idrepresk foreign key (id_representante) references representante (id);




create table producto(
id 				number 							not null,
nombre 			varchar2(300) 					not null,
descripcion 	varchar2(2000) 					not null,
disponible		number							not null,
precio 			number(10,2) 					not null,
descuento 		number(10,2) 					not null,
image_1 		varchar2(100) 					not null,
image_2 		varchar2(100) 					not null,
habilitado		varchar2(1)		default 'V'		not null
);

--Secuencia
create sequence producto_sequence start with 1;
--Primary key
alter table producto add constraint prodIdPk primary key(id) using index;
--Nombre index
create index proNombreIndex on producto (nombre);



create table atributo(
id 		number 			not null,
nombre 	varchar2(50) 	not null --Color, Tamaño, Talla
);

--Secuencia
create sequence atributo_sequence start with 1;
--Primary KEY
alter table atributo add constraint atributoIdPk primary key (id) using index;
--Nombre Unico
alter table atributo add constraint atributoNombreUq unique(nombre) using index;



create table atributo_valor(
id 				number 			not null,
id_atributo 	number 			not null,
valor			varchar(100) 	not null	--Rolo, Grande, XL
);

--Secuencia
create sequence atributo_valor_sequence start with 1;
--Primary key 
alter table atributo_valor add constraint atributo_valorIdPk primary key (id) using index;
--Foreign Key (id_attributo)
alter table atributo_valor add constraint atributo_valorIdAtributoFk foreign key (id_atributo) references atributo (id);
--Indice
create index atributo_valorValorKey on atributo_valor(valor);



create table producto_atributo(
id_producto 	number 	not null, 
id_atributo 	number 	not null
);

alter table producto_atributo add constraint proAtrIdProductoFk foreign key (id_producto) references producto (id);
alter table producto_atributo add constraint proAtrIdAtributoFk foreign key (id_atributo) references atributo_valor(id);


create table proveedor_producto(
id_proveedor number not null,
id_producto number not null
);

alter table proveedor_producto add constraint proProIdProveedorFk foreign key (id_proveedor) references proveedor (id);
alter table proveedor_producto add constraint proProIdProductoFk foreign key (id_producto) references producto(id);
alter table proveedor_producto add constraint proProIdProductoUq unique(id_producto) using index;


create table departamento(
id number not null,
nombre varchar2(150) not null
);

--Secuencia
create sequence departamento_sequence start with 1;
--Primary KEY
alter table departamento add constraint departamentoIdPk primary key (id) using index;
--Unico
alter table departamento add constraint departamentoNombreUq unique(nombre) using index;


create table categoria(
id number not null,
id_departamento number not null,
nombre varchar(150) not null
);

--Sequence
create sequence categoria_sequence start with 1;
--Primary key
alter table categoria add constraint categoriaIdPk primary key (id) using index;
--Foreign KEY
alter table categoria add constraint categoriaIdDepartamentoFk foreign key (id_departamento) references departamento (id);
--UNIQUE
alter table categoria add constraint categoriaNombreUq unique (nombre) using index;


create table producto_categoria(
id_producto number not null,
id_categoria number not null
);

--FOREIGN KEY (Producto)
alter table producto_categoria add constraint producto_categoriaidproductofk foreign key (id_producto) references producto (id);
--FOREIGN KEY (Categoria)
alter table producto_categoria add constraint productocategoriaidcategoriafk foreign key (id_categoria) references categoria (id);


--Para no clientes(Not login)
create table carro_temp(
id 					number 							not null,
id_session 			number 							not null,
id_producto			number							not null,
cantidad			number	default 1				not null,
fecha_registro		date 	default sysdate			not null,
fecha_modificado	date	default sysdate			not null
);

--Sequence
create sequence carro_temp_sequence start with 1;
--Primary KEY
alter table carro_temp add constraint carro_tempIdPk primary key (id) using index;
--Indice
create index carro_tempIdSessionUq on carro_temp (id_session);
--Foreign Key id_producto (Producto)
alter table carro_temp add constraint carro_tempIdProductoFk foreign key (id_producto)  references producto (id);

--Para Clientes(login)
create table carro(
id 					number 							not null,
id_cliente 			number 							not null,
id_producto			number							not null,
cantidad			number	default 1				not null,
fecha_registro		date 	default sysdate			not null,
fecha_modificado	date	
);
--Sequence
create sequence carro_sequence start with 1;
--Primary KEY
alter table carro add constraint carroIdPk primary key (id) using index;
--Foreign Key id_cliente (Cliente)
alter table carro add constraint carro_idClienteFk foreign key (id_cliente)  references usuario (id);
--Foreign Key id_producto (Producto)
alter table carro add constraint carroIdProductoFk foreign key (id_producto) references producto (id);

create table orden(
id 				number 			not null,
id_cliente 		number 			not null,
total 			number(10,2) 	not null,
num_TDC 		number 			not null,
status 			varchar2(5) 	not null,
fecha_envio 	date 			not null,
fecha_order 	date default sysdate not null
);

--Secuencia
create sequence orden_sequence start with 1;
--Primary Key
alter table orden add constraint ordenIdPk primary key (id) using index;
--FOREIGN KEY id_cliente (Cliente)
alter table orden add constraint orden_id_cliente_fk foreign key (id_cliente) references usuario (id);



create table orden_item(
id number not null,
id_orden number not null,
id_producto number not null,
cantidad number not null,
precio number not null
);

--SEQUENCE
create sequence order_item_sequence start with 1;
--Primary KEY
alter table orden_item add constraint order_itemIdPk primary key (id) using index;
--FOREIGN KEY id_orden (Orden)
alter table orden_item add constraint orden_itemIdOrdenFk foreign key (id_orden) references orden (id);
--FOREIGN KEY id_producto (producto)
alter table orden_item add constraint orden_itemIdProductoFk foreign key (id_producto) references producto (id);
