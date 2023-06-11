package model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Prontuario {

	private Paciente paciente;
	private String diagnostico;
}
