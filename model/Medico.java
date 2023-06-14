package com.les.healthworks.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Medico extends Pessoa{

	private String crm;
	private String cargo;
	private int especialidade;
}
