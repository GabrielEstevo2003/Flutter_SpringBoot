package com.example.AgendaFlutterBackEnd.Repositories;

import com.example.AgendaFlutterBackEnd.Models.Agenda;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AgendaRepository extends MongoRepository<Agenda, String> {
}
