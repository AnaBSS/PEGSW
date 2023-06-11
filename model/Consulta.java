package model;

import java.time.LocalDate;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Consulta {

	private LocalDate dataHora;
	private Medico medico;
	private Paciente paciente;
	private Especialidade especialidade;
}
