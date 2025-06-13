CREATE TABLE Nivel_Seguridad (
	idNivel_Seguridad SERIAL NOT NULL,
	descripción_Nv_Seg ENUM("baja", "media", "alta"),
	PRIMARY KEY (idNivel_Seguridad)
);

create table Empleado(
	num_legajo serial not null,
    nombre_empleado VARCHAR(30) NOT NULL,
    teléfono VARCHAR(30),
    dirección VARCHAR(30),
    fecha_nac date, 
    género enum("Hombre", "Mujer"), 
    huella_dactilar VARCHAR(30) NOT NULL,
    contraseña_acceso VARCHAR(30) NOT NULL, 
    categoría enum("Jerárquico", "Profesional", "No Profesional")not null, 
    id_Nivel_Seguridad INT NOT NULL,
    FOREIGN KEY (id_Nivel_Seguridad) REFERENCES Nivel_Seguridad(idNivel_Seguridad),
    primary key (num_legajo)
);

create table Empleado_Jerárquico(
	num_legajo serial not null,
    idÁrea int not null,
    fecha_asignación date not null,
    FOREIGN KEY (num_legajo) REFERENCES Empleado(num_legajo),
    FOREIGN KEY (idÁrea) REFERENCES Área(idÁrea),
    primary key (num_legajo)
);

create table Empleado_No_Profesional(
	num_legajo serial not null,
    FOREIGN KEY (num_legajo) REFERENCES Empleado(num_legajo),
    primary key (num_legajo)
);

create table Empleado_Profesional(
	num_legajo serial not null,
    tipo enum("Contratado", "Permanente") not null,
    FOREIGN KEY (num_legajo) REFERENCES Empleado(num_legajo),
    primary key (num_legajo)
);

create table Empleado_Profesional_Contratado(
	num_legajo serial not null,
    FOREIGN KEY (num_legajo) REFERENCES Empleado_Profesional(num_legajo),
    primary key (num_legajo)
);

create table Empleado_Profesional_Permanente(
	num_legajo serial not null,
	idÁrea int not null,
    FOREIGN KEY (num_legajo) REFERENCES Empleado_Permanente(num_legajo),
    FOREIGN KEY (idÁrea) REFERENCES Área(idÁrea),
    primary key (num_legajo)
);

CREATE TABLE Área (
	idÁrea SERIAL NOT NULL,
	nombre VARCHAR(30) NOT NULL UNIQUE,
    id_Nivel_Seguridad INT NOT NULL,
    FOREIGN KEY (id_Nivel_Seguridad) REFERENCES Nivel_Seguridad(idNivel_Seguridad),
	PRIMARY KEY (idÁrea)
);

CREATE TABLE Turno (
	idTurno SERIAL NOT NULL,
	horario enum("8-12hs","12-16sh","16-20hs") NOT NULL UNIQUE,
	PRIMARY KEY (idTurno)
);

create table Autorización(
	idTurno int not null,
    idÁrea int not null,
    num_legajo int not null,
    FOREIGN KEY (idTurno) REFERENCES Turno(idTurno),
    FOREIGN KEY (idÁrea) REFERENCES Área(idÁrea),
    FOREIGN KEY (num_legajo) REFERENCES Empleado_No_Profesional(num_legajo),
    primary key(num_legajo, idTurno)
);

create table Registro_Acceso(
	idRegistro_Acceso serial not null,
    num_legajo int not null,
    idÁrea int not null,
    fecha_hora datetime not null,
    tipo_acceso enum("Ingreso", "Egreso") not null,
    autorizado bool not null, 
    medio enum("Huella dactical", "Contraseña") not null,
    FOREIGN KEY (num_legajo) REFERENCES Empleado(num_legajo),
    FOREIGN KEY (idÁrea) REFERENCES Área(idÁrea),
    primary key(idRegistro_Acceso)
);

create table Evento(
	num_evento serial not null,
    idÁrea int not null,
    fecha_hora datetime, 
    descripción varchar(30),
    FOREIGN KEY (idÁrea) REFERENCES Área(idÁrea),
    primary key (idÁrea, num_evento)
);

create table Contrato(
	idContrato serial not null,
    num_legajo int not null,
    idÁrea int not null,
    descripción varchar(30),
    fecha_in date,
    fecha_fin date,
    FOREIGN KEY (num_legajo) REFERENCES Empleado_Profesional_Contratado(num_legajo),
    FOREIGN KEY (idÁrea) REFERENCES Área(idÁrea),
    primary key(idContrato)
);