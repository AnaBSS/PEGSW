package com.les.healthworks.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.les.healthworks.model.Atendente;
import com.les.healthworks.persistence.GestorDAO;

@Controller
public class GestorProfiController {
	
	@Autowired
	GestorDAO gDao;
	
	@RequestMapping(name = "gestorProfi", value = "/gestorProfi", method = RequestMethod.GET)
    public ModelAndView init(ModelMap model){
		List<Atendente> atendentes = new ArrayList<>();
		
		try {
			atendentes = gDao.listaAtendentes();
		}catch (SQLException | ClassNotFoundException e){
			e.getMessage();
		}finally {
			model.addAttribute("atendente", atendentes);
		}
        return new ModelAndView("gestorProfi");
    }
	
	@RequestMapping(value = "/deleteAtendente/{cpf}/{email}", method = RequestMethod.GET)
    public String deleteAtendente(@PathVariable("cpf") String cpf, @PathVariable("email") String email) throws ClassNotFoundException, SQLException {
		Atendente a = new Atendente();
		a.setCpf(cpf);
		a.setEmail(email);
        gDao.excluiAtendente(a);
        return "redirect:/gestorProfi";
    }
	
	 @RequestMapping(value = "/editAtendente/{cpf}", method = RequestMethod.GET)
	 public String showEditAtendente(@PathVariable("cpf") String cpf, ModelMap model) throws ClassNotFoundException, SQLException {
		 Atendente a = new Atendente();
		 a.setCpf(cpf);
		 
		 Atendente atendente = gDao.pesquisaAtendente(a);
	     model.addAttribute("a", atendente);
	     return "editAtendente";
	 }
	 
	 @RequestMapping(value = "/editAtendente", method = RequestMethod.POST)
	 public String update(ModelMap model, @RequestParam Map<String, String> params) throws ClassNotFoundException, SQLException {
		 String cpf = params.get("cpf");
		 String nome = params.get("nome");
		 String email = params.get("email");
		 String senha = params.get("senha");
		 String telefone = params.get("telefone");
		 String cargo = params.get("cargo");
		 String botao = params.get("botao");
		 
		 if (botao.equalsIgnoreCase("atualizar profissional")) {
			 Atendente a = new Atendente();
			 a.setCpf(cpf);
			 a.setNome(nome);
			 a.setEmail(email);
			 a.setSenha(senha);
			 a.setTelefone(telefone);
			 a.setCargo(cargo);
			 
			 gDao.editaAtendente(a);
		 }

		 return "redirect:/gestorProfi";
	 }
	
	
	
	@RequestMapping(name = "gestorProfi", value = "/gestorProfi", method = RequestMethod.POST)
	public ModelAndView profissionais(ModelMap model, @RequestParam Map<String, String> allParam) {
		return new ModelAndView("gestorProfi");
	}
}
