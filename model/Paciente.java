package model;

import java.time.LocalDate;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Paciente extends Pessoa{

	private LocalDate dataNasc;
	private String cartaoSUS;
	private String tipoSanguineo;
	private Double peso;
	private String sexo;
	private Double altura;
}
