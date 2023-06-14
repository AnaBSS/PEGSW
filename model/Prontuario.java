package com.les.healthworks.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Prontuario {
	private int cod;
	private String paciente;
	private String medico;
	private String diagnostico;
}
