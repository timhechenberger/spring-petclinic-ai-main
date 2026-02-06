package org.springframework.samples.petclinic.repository.springdatajpa;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.samples.petclinic.model.TimelineEvent;

public interface SpringDataTimelineEventRepository extends JpaRepository<TimelineEvent, Integer> {

    List<TimelineEvent> findByPetIdOrderByEventDateDescCreatedAtDesc(Integer petId);
}
