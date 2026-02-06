package org.springframework.samples.petclinic.repository.springdatajpa;

import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.samples.petclinic.model.TimelineEvent;
import org.springframework.samples.petclinic.repository.TimelineEventRepository;
import org.springframework.stereotype.Repository;

@Repository
public class SpringDataTimelineEventRepositoryAdapter implements TimelineEventRepository {

    private final SpringDataTimelineEventRepository repo;

    public SpringDataTimelineEventRepositoryAdapter(SpringDataTimelineEventRepository repo) {
        this.repo = repo;
    }

    @Override
    public List<TimelineEvent> findByPetId(int petId) throws DataAccessException {
        return repo.findByPetIdOrderByEventDateDescCreatedAtDesc(petId);
    }

    @Override
    public TimelineEvent findById(int id) throws DataAccessException {
        return repo.findById(id).orElse(null);
    }

    @Override
    public void save(TimelineEvent event) throws DataAccessException {
        repo.save(event);
    }

    @Override
    public void delete(TimelineEvent event) throws DataAccessException {
        repo.delete(event);
    }
}
