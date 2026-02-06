package org.springframework.samples.petclinic.service;

import java.util.List;

import org.springframework.samples.petclinic.model.Pet;
import org.springframework.samples.petclinic.model.TimelineEvent;
import org.springframework.samples.petclinic.repository.PetRepository;
import org.springframework.samples.petclinic.repository.TimelineEventRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TimelineEventServiceImpl implements TimelineEventService {

    private final TimelineEventRepository timelineRepo;
    private final PetRepository petRepo;

    public TimelineEventServiceImpl(TimelineEventRepository timelineRepo, PetRepository petRepo) {
        this.timelineRepo = timelineRepo;
        this.petRepo = petRepo;
    }

    @Override
    @Transactional(readOnly = true)
    public List<TimelineEvent> getTimelineForPet(int petId) {
        ensurePetExists(petId);
        return timelineRepo.findByPetId(petId);
    }

    @Override
    @Transactional
    public TimelineEvent createForPet(int petId, TimelineEvent event) {
        Pet pet = ensurePetExists(petId);
        event.setPet(pet);
        timelineRepo.save(event);
        return event;
    }

    @Override
    @Transactional
    public TimelineEvent updateForPet(int petId, int eventId, TimelineEvent patch) {
        ensurePetExists(petId);

        TimelineEvent existing = timelineRepo.findById(eventId);
        if (existing == null) {
            throw new IllegalArgumentException("TimelineEvent not found: " + eventId);
        }

        if (existing.getPet() == null || existing.getPet().getId() == null || existing.getPet().getId() != petId) {
            throw new IllegalArgumentException("TimelineEvent does not belong to petId=" + petId);
        }

        existing.setEventDate(patch.getEventDate());
        existing.setType(patch.getType());
        existing.setTitle(patch.getTitle());
        existing.setDescription(patch.getDescription());

        timelineRepo.save(existing);
        return existing;
    }

    @Override
    @Transactional
    public void deleteForPet(int petId, int eventId) {
        ensurePetExists(petId);

        TimelineEvent existing = timelineRepo.findById(eventId);
        if (existing == null) {
            throw new IllegalArgumentException("TimelineEvent not found: " + eventId);
        }

        if (existing.getPet() == null || existing.getPet().getId() == null || existing.getPet().getId() != petId) {
            throw new IllegalArgumentException("TimelineEvent does not belong to petId=" + petId);
        }

        timelineRepo.delete(existing);
    }

    private Pet ensurePetExists(int petId) {
        // PetRepository wirft laut Doku Exception wenn nicht gefunden -> passt
        return petRepo.findById(petId);
    }
}
