package org.springframework.samples.petclinic.repository;

import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.samples.petclinic.model.TimelineEvent;

public interface TimelineEventRepository {

    List<TimelineEvent> findByPetId(int petId) throws DataAccessException;

    TimelineEvent findById(int id) throws DataAccessException;

    void save(TimelineEvent event) throws DataAccessException;

    void delete(TimelineEvent event) throws DataAccessException;
}
