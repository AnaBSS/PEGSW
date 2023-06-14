package com.les.healthworks.model;

import java.sql.Date;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Paciente extends Pessoa{
	private Date dataNasc;
	private String cartaoSUS;
	private String tipoSanguineo;
	private Double peso;
	private String genero;
	private Double altura;
}
