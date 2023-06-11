package persistence;

import java.sql.SQLException;

import model.Pessoa;

public interface IPessoaDAO {
	public void realizarLogin(Pessoa p) throws ClassNotFoundException, SQLException;
}
