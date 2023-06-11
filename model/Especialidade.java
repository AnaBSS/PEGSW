package model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Especialidade extends Pessoa{

	private String nome;
	private String descricao;
}
