package persistence;

import java.sql.SQLException;

import model.Especialidade;
import model.Medico;

public interface IEspecialidadeDAO {
	public Especialidade listaMedicoEspecialidade(Medico m) throws SQLException;
}
