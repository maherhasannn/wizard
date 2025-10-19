import prisma from '../../lib/prismaClient';
import { AppError } from '../../middleware/errorHandler';

class PowerService {
  async getCategories() {
    const categories = await prisma.powerCategory.findMany({
      where: { isActive: true },
      orderBy: { sortOrder: 'asc' },
    });

    return categories;
  }

  async saveSelections(userId: number, categoryIds: number[]) {
    return await prisma.$transaction(async (tx) => {
      // Delete existing selections
      await tx.userPowerSelection.deleteMany({
        where: { userId },
      });

      // Create new selections
      const selections = await tx.userPowerSelection.createMany({
        data: categoryIds.map((powerCategoryId, index) => ({
          userId,
          powerCategoryId,
          priority: index + 1,
        })),
      });

      return { message: 'Selections saved successfully', count: selections.count };
    });
  }

  async getSelections(userId: number) {
    const selections = await prisma.userPowerSelection.findMany({
      where: { userId },
      orderBy: { priority: 'asc' },
      include: {
        powerCategory: true,
      },
    });

    return selections;
  }
}

export default new PowerService();

