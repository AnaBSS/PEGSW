package com.les.healthworks.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Pessoa {

	private String nome;
	private String cpf;
	private String email;
	private String senha;
	private String telefone;
}
