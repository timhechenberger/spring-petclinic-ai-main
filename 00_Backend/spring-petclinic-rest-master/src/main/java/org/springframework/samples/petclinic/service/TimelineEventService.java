package org.springframework.samples.petclinic.service;

import java.util.List;

import org.springframework.samples.petclinic.model.TimelineEvent;

public interface TimelineEventService {

    List<TimelineEvent> getTimelineForPet(int petId);

    TimelineEvent createForPet(int petId, TimelineEvent event);

    TimelineEvent updateForPet(int petId, int eventId, TimelineEvent patch);

    void deleteForPet(int petId, int eventId);
}
