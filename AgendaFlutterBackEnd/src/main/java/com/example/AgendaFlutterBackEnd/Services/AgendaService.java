package com.example.AgendaFlutterBackEnd.Services;

import com.example.AgendaFlutterBackEnd.Models.Agenda;
import com.example.AgendaFlutterBackEnd.Repositories.AgendaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AgendaService {
    @Autowired
    private AgendaRepository agendaRepository;

    public Agenda save(Agenda agenda){
        return agendaRepository.save(agenda);
    }

    public List<Agenda> findAll(){
        return agendaRepository.findAll();
    }

    public Optional<Agenda> findById(String id){
        return agendaRepository.findById(id);
    }

    public void deleteById(String id){
        agendaRepository.deleteById(id);
    }
}
