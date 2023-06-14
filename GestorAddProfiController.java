package com.les.healthworks.controller;

import java.sql.SQLException;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.les.healthworks.model.Atendente;
import com.les.healthworks.persistence.GestorDAO;

@Controller
public class GestorAddProfiController {
	
	@Autowired
	GestorDAO gDao;
	
	@RequestMapping(name = "gestorAddProfi", value = "/gestorAddProfi", method = RequestMethod.GET)
    public ModelAndView init(ModelMap model){
        return new ModelAndView("gestorAddProfi");
    }
	
	@RequestMapping(name = "gestorAddProfi", value = "/gestorAddProfi", method = RequestMethod.POST)
    public ModelAndView adicionarProfissional(@RequestParam Map<String, String> params, ModelMap model) throws SQLException, ClassNotFoundException{
		
		String cpf = params.get("cpf");
		String nome = params.get("nome");
		String email = params.get("email");
		String senha = params.get("senha");
		String telefone = params.get("telefone");
		String cargo = params.get("cargo");
		String botao = params.get("botao");
		
		if(botao.equalsIgnoreCase("adicionar profissional")) {
			if(cargo == "A") {
				
			}else {
				Atendente a = new Atendente();
				a.setCpf(cpf);
				a.setNome(nome);
				a.setEmail(email);
				a.setSenha(senha);
				a.setTelefone(telefone);
				a.setCargo(cargo);
				
				gDao.cadastraAtendente(a);
			}
		}
		
        return new ModelAndView("gestorAddProfi");
    }
	
}
