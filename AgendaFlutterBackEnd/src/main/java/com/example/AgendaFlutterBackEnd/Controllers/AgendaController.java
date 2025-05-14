package com.example.AgendaFlutterBackEnd.Controllers;

import com.example.AgendaFlutterBackEnd.Models.Agenda;
import com.example.AgendaFlutterBackEnd.Services.AgendaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/agenda")
@CrossOrigin(origins = "*")
public class AgendaController {

    @Autowired
    private AgendaService agendaService;

    @PostMapping
    public ResponseEntity<Agenda> criar(@RequestBody Agenda agenda) {
        Agenda salvo = agendaService.save(agenda);
        return ResponseEntity.status(HttpStatus.CREATED).body(salvo); // <-- HTTP 201
    }


    @PutMapping("/{id}")
    public Optional<Agenda> update(@PathVariable("id") String id, @RequestBody Agenda novo){
        return Optional.ofNullable(agendaService.findById(id).map(agenda -> {
            agenda.setNomePaciente(novo.getNomePaciente());
            agenda.setDataConsulta(novo.getDataConsulta());
            agenda.setHoraConsulta(novo.getHoraConsulta());
            agenda.setTipoTratamento(novo.getTipoTratamento());
            agenda.setCep(novo.getCep());
            agenda.setCidade(novo.getCidade());
            agenda.setEstado(novo.getEstado());
            agenda.setLocalidade(novo.getLocalidade());
            agenda.setObservacoes(novo.getObservacoes());
            return agendaService.save(agenda);
        }).orElseGet(() -> {
            novo.setId(id);
            return agendaService.save(novo);
        }));
    }

    @GetMapping
    public List<Agenda> findAll(){
        return agendaService.findAll();
    }

    @GetMapping("/{id}")
    public Optional<Agenda> findById(@PathVariable ("id") String id){
        return agendaService.findById(id);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable String id) {
        agendaService.deleteById(id);
        return ResponseEntity.noContent().build(); // Retorna HTTP 204 No Content
    }
}
