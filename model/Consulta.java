package com.les.healthworks.model;

import java.sql.Date;
import java.sql.Time;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Consulta {
	private int cod;
	private Date data;
	private Time hora;
	private String medico;
	private String paciente;
	private int especialidade;
}
